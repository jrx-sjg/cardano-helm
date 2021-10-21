######################################
# User Variables - Change as desired #
# Common variables set in env file   #
######################################

#CPU_CORES=2                                            # Number of CPU cores cardano-node process has access to (please don't set higher than physical core count, 2-4 recommended)
CNODE_LISTEN_IP4=0.0.0.0                                # IP to use for listening (only applicable to Node Connection Port) for IPv4
#CNODE_LISTEN_IP6=::                                    # IP to use for listening (only applicable to Node Connection Port) for IPv6
CNODEBIN="${HOME}/.cabal/bin/cardano-node"              # Override automatic detection of cardano-node executable
#CCLI="${HOME}/.cabal/bin/cardano-cli"                  # Override automatic detection of cardano-cli executable
#CNCLI="${HOME}/.cargo/bin/cncli"                       # Override automatic detection of executable (https://github.com/AndrewWestberg/cncli)
CNODE_PORT=6000                                         # Set node port
CONFIG="${CNODE_HOME}/files/mainnet-config.json"        # Override automatic detection of node config path
#SOCKET="${CNODE_HOME}/sockets/node0.socket"            # Override automatic detection of path to socket
TOPOLOGY="${CNODE_HOME}/files/mainnet-topology.json"    # Override default topology.json path
LOG_DIR="${CNODE_HOME}/logs"                           # Folder where your logs will be sent to (must pre-exist)
#DB_DIR="${CNODE_HOME}/db"                              # Folder to store the cardano-node blockchain db
#TMP_DIR="/tmp/cnode"                                   # Folder to hold temporary files in the various scripts, each script might create additional subfolders
#USE_EKG="Y"                                            # Use EKG metrics from the node instead of Prometheus. Prometheus metrics yield slightly better performance but can be unresponsive at times (default EKG)
EKG_HOST=127.0.0.1                                      # Set node EKG host IP
#EKG_PORT=12788                                         # Override automatic detection of node EKG port
#PROM_HOST=127.0.0.1                                    # Set node Prometheus host IP
#PROM_PORT=12798                                        # Override automatic detection of node Prometheus port
#EKG_TIMEOUT=3                                          # Maximum time in seconds that you allow EKG request to take before aborting (node metrics)
#CURL_TIMEOUT=10                                        # Maximum time in seconds that you allow curl file download to take before aborting (GitHub update process)
#BLOCKLOG_DIR="${CNODE_HOME}/blocklog"                  # Override default directory used to store block data for core node
#BLOCKLOG_TZ="UTC"                                      # TimeZone to use when displaying blocklog - https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#SHELLEY_TRANS_EPOCH=208                                # Override automatic detection of shelley epoch start, e.g 208 for mainnet
#TIMEOUT_LEDGER_STATE=300                               # Timeout in seconds for querying and dumping ledger-state
IP_VERSION=4                                            # The IP version to use for push and fetch, valid options: 4 | 6 | mix (Default: 4)

#POOL_FOLDER="${CNODE_HOME}/priv/pool"                  # Root folder for Pools
#POOL_NAME=""                                           # Set the pool's name to run node as a core node (the name, NOT the ticker, ie folder name)


######################################
# Do NOT modify code below           #
######################################

[[ -z ${CNODE_LISTEN_IP4} ]] && CNODE_LISTEN_IP4=0.0.0.0
[[ -z ${CNODE_LISTEN_IP6} ]] && CNODE_LISTEN_IP6=::

if [[ -S "${CARDANO_NODE_SOCKET_PATH}" ]]; then
  if pgrep -f "$(basename ${CNODEBIN}).*.${CARDANO_NODE_SOCKET_PATH}"; then
     echo "ERROR: A Cardano node is already running, please terminate this node before starting a new one with this script."
     exit 1
  else
    echo "WARN: A prior running Cardano node was not cleanly shutdown, socket file still exists. Cleaning up."
    unlink "${CARDANO_NODE_SOCKET_PATH}"
  fi
fi

[[ -n ${CPU_CORES} ]] && CPU_RUNTIME=( "+RTS" "-N${CPU_CORES}" "-RTS" ) || CPU_RUNTIME=()

[[ ! -d "${LOG_DIR}/archive" ]] && mkdir -p "${LOG_DIR}/archive"

[[ $(find "${LOG_DIR}"/*.json 2>/dev/null | wc -l) -gt 0 ]] && mv "${LOG_DIR}"/*.json "${LOG_DIR}"/archive/

host_addr=()
[[ ${IP_VERSION} = "4" || ${IP_VERSION} = "mix" ]] && host_addr+=("--host-addr" "${CNODE_LISTEN_IP4}")
[[ ${IP_VERSION} = "6" || ${IP_VERSION} = "mix" ]] && host_addr+=("--host-ipv6-addr" "${CNODE_LISTEN_IP6}")

if [[ -f "${POOL_DIR}/${POOL_OPCERT_FILENAME}" && -f "${POOL_DIR}/${POOL_VRF_SK_FILENAME}" && -f "${POOL_DIR}/${POOL_HOTKEY_SK_FILENAME}" ]]; then
  "${CNODEBIN}" "${CPU_RUNTIME[@]}" run \
    --topology "${TOPOLOGY}" \
    --config "${CONFIG}" \
    --database-path "${DB_DIR}" \
    --socket-path "${CARDANO_NODE_SOCKET_PATH}" \
    --shelley-kes-key "${POOL_DIR}/${POOL_HOTKEY_SK_FILENAME}" \
    --shelley-vrf-key "${POOL_DIR}/${POOL_VRF_SK_FILENAME}" \
    --shelley-operational-certificate "${POOL_DIR}/${POOL_OPCERT_FILENAME}" \
    --port ${CNODE_PORT} \
    "${host_addr[@]}"
else
  "${CNODEBIN}" "${CPU_RUNTIME[@]}" run \
    --topology "${TOPOLOGY}" \
    --config "${CONFIG}" \
    --database-path "${DB_DIR}" \
    --socket-path "${CARDANO_NODE_SOCKET_PATH}" \
    --port ${CNODE_PORT} \
    "${host_addr[@]}"
fi