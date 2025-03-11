#!/bin/bash

# network_traffic.sh [-tPOLLING_INTERVAL] [NETWORK_INTERFACE...]

getopts t: __ && shift
isecs=${OPTARG:-1}
ifaces=($@)
: ${rate_max:=1000000} # maximum transfer rate for {percent}, can be overridden by setting the env var

# `snore` adapted from https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || { exec {_snore_fd}<> <(:); } 2>/dev/null
    read ${1:+-t "$1"} -u $_snore_fd || :
}

human_readable() {
  local hrunits=( B K M G T P )
  local ndigits=${#1}
  local idxunit=$(( (2 + ndigits) / 3 - 1))
  local lentrim=$(( ndigits - (idxunit * 3 ) ))
  echo ${1::$lentrim}${hrunits[$idxunit]}
}

exit_err() {
  printf '{"text": "⚠ %s", "tooltip": "%s", "class": "error"}\n' "$@"
  exit
}

if test ${#ifaces[@]} -gt 0; then
  # sanity check the interface names
  for iface in ${ifaces[@]}; do
    test -h "/sys/class/net/${iface}" || exit_err "${iface}" "${iface} is not an existing network interface name"
  done
else
  # default to all interfaces except `lo`
  ifaces=(/sys/class/net/*)
  ifaces=(${ifaces[@]##*/})
  ifaces=(${ifaces[@]//lo/})
fi

# sanity check polling interval
if test ${isecs} -lt 1; then
  exit_err "${isecs}" "${isecs} is not a valid polling interval"
fi

# Set initial values for the traffic arrays
declare -A traffic_prev traffic_curr traffic_delt

# Initialize the traffic arrays for each interface
for iface in ${ifaces[@]} aggregate; do
  # Initialize with zeros for each individual traffic value
  traffic_prev["${iface}_rx_bytes"]=0
  traffic_prev["${iface}_tx_bytes"]=0
  traffic_prev["${iface}_rx_packets"]=0
  traffic_prev["${iface}_tx_packets"]=0
  traffic_prev["${iface}_rx_errors"]=0
  traffic_prev["${iface}_tx_errors"]=0
  traffic_prev["${iface}_rx_dropped"]=0
  traffic_prev["${iface}_tx_dropped"]=0
  traffic_curr["${iface}_rx_bytes"]=0
  traffic_curr["${iface}_tx_bytes"]=0
  traffic_curr["${iface}_rx_packets"]=0
  traffic_curr["${iface}_tx_packets"]=0
  traffic_curr["${iface}_rx_errors"]=0
  traffic_curr["${iface}_tx_errors"]=0
  traffic_curr["${iface}_rx_dropped"]=0
  traffic_curr["${iface}_tx_dropped"]=0
  traffic_delt["${iface}_rx_bytes"]=0
  traffic_delt["${iface}_tx_bytes"]=0
  traffic_delt["${iface}_rx_packets"]=0
  traffic_delt["${iface}_tx_packets"]=0
  traffic_delt["${iface}_rx_errors"]=0
  traffic_delt["${iface}_tx_errors"]=0
  traffic_delt["${iface}_rx_dropped"]=0
  traffic_delt["${iface}_tx_dropped"]=0
done

# TODO: rearrange the loop, do not show bogus on first iteration
while snore ${isecs} ; do
  tooltip=""
  traffic_delt_aggregate_rx=0
  traffic_delt_aggregate_tx=0

  readarray -s2 proc_net_dev </proc/net/dev
  while read -a data; do
    iface=${data[0]%:}
    test "${ifaces[*]}" = "${ifaces[*]//${iface}/}" && continue

    # Get previous and current values for RX/TX bytes, packets, errors, dropped
    prev_rx_bytes=${traffic_prev["${iface}_rx_bytes"]}
    prev_tx_bytes=${traffic_prev["${iface}_tx_bytes"]}
    prev_rx_packets=${traffic_prev["${iface}_rx_packets"]}
    prev_tx_packets=${traffic_prev["${iface}_tx_packets"]}
    prev_rx_errors=${traffic_prev["${iface}_rx_errors"]}
    prev_tx_errors=${traffic_prev["${iface}_tx_errors"]}
    prev_rx_dropped=${traffic_prev["${iface}_rx_dropped"]}
    prev_tx_dropped=${traffic_prev["${iface}_tx_dropped"]}

    curr_rx_bytes=${data[1]}
    curr_tx_bytes=${data[9]}
    curr_rx_packets=${data[2]}
    curr_tx_packets=${data[10]}
    curr_rx_errors=${data[3]}
    curr_tx_errors=${data[11]}
    curr_rx_dropped=${data[4]}
    curr_tx_dropped=${data[12]}

    # Update traffic deltas
    traffic_delt["${iface}_rx_bytes"]=$(( (curr_rx_bytes - prev_rx_bytes) / isecs ))
    traffic_delt["${iface}_tx_bytes"]=$(( (curr_tx_bytes - prev_tx_bytes) / isecs ))
    traffic_delt["${iface}_rx_packets"]=$(( (curr_rx_packets - prev_rx_packets) / isecs ))
    traffic_delt["${iface}_tx_packets"]=$(( (curr_tx_packets - prev_tx_packets) / isecs ))
    traffic_delt["${iface}_rx_errors"]=$(( (curr_rx_errors - prev_rx_errors) / isecs ))
    traffic_delt["${iface}_tx_errors"]=$(( (curr_tx_errors - prev_tx_errors) / isecs ))
    traffic_delt["${iface}_rx_dropped"]=$(( (curr_rx_dropped - prev_rx_dropped) / isecs ))
    traffic_delt["${iface}_tx_dropped"]=$(( (curr_tx_dropped - prev_tx_dropped) / isecs ))

    # Update the aggregate counters
    traffic_delt_aggregate_rx=$(( traffic_delt_aggregate_rx + traffic_delt["${iface}_rx_bytes"] ))
    traffic_delt_aggregate_tx=$(( traffic_delt_aggregate_tx + traffic_delt["${iface}_tx_bytes"] ))

    # Store updated traffic_curr as individual values
    traffic_prev["${iface}_rx_bytes"]=$curr_rx_bytes
    traffic_prev["${iface}_tx_bytes"]=$curr_tx_bytes
    traffic_prev["${iface}_rx_packets"]=$curr_rx_packets
    traffic_prev["${iface}_tx_packets"]=$curr_tx_packets
    traffic_prev["${iface}_rx_errors"]=$curr_rx_errors
    traffic_prev["${iface}_tx_errors"]=$curr_tx_errors
    traffic_prev["${iface}_rx_dropped"]=$curr_rx_dropped
    traffic_prev["${iface}_tx_dropped"]=$curr_tx_dropped
  done <<<"${proc_net_dev[@]}"

  printf '{"text": "%4s⇣ %4s⇡", "tooltip": "%s",  "percentage": %d}\n'   \
    $(human_readable $traffic_delt_aggregate_rx)  \
    $(human_readable $traffic_delt_aggregate_tx)  \
    "${tooltip}"                                    \
    $(( (traffic_delt_aggregate_rx + traffic_delt_aggregate_tx) / rate_max ))
done

