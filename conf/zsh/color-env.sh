# Harmonize NO_COLOR / FORCE_COLOR for Node and CLI tools.
# Node warns when both are set; FORCE_COLOR=0 still counts as "force color".
# shellcheck shell=sh
color_env_harmonize() {
  if [ -n "${NO_COLOR-}" ] && [ -n "${FORCE_COLOR-}" ]; then
    case ${FORCE_COLOR} in
      0 | false) unset FORCE_COLOR ;;
      *) unset NO_COLOR ;;
    esac
  fi
  case ${FORCE_COLOR-} in
    0 | false) unset FORCE_COLOR ;;
  esac
}
