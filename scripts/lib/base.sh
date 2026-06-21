# shellcheck shell=bash
#
# resolve_base_group <BOARD_SOC>
#
# Echoes the name of the configured-base group that covers a given BOARD_SOC, or
# nothing if no base applies (e.g. RK3566 / RK3576 boards build straight from the
# rootfs). A base group is defined by a config/bases/<group>.sh file that exports
# BASE_NAME and a BASE_SOCS=(...) array of the BOARD_SOC strings it covers.
#
# Used by build.sh (local full build) and by the CI matrix-generation step so both
# agree on which boards consume a pre-baked base.

resolve_base_group() {
    local soc="$1"
    local bases_dir
    bases_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../config/bases" 2>/dev/null && pwd)" || return 0
    [ -d "${bases_dir}" ] || return 0

    local f name
    for f in "${bases_dir}"/*.sh; do
        [ -e "${f}" ] || continue
        # Source in a subshell so BASE_* vars never leak into the caller's env.
        name="$(
            BASE_NAME=""
            declare -a BASE_SOCS=()
            # shellcheck source=/dev/null
            source "${f}"
            for s in "${BASE_SOCS[@]}"; do
                if [ "${s}" == "${soc}" ]; then
                    echo "${BASE_NAME}"
                    break
                fi
            done
        )"
        if [ -n "${name}" ]; then
            echo "${name}"
            return 0
        fi
    done
}
