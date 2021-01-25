# check for distro,
# works on RHEL,CENTOS,Debian,Ubuntu,Mint,SuSE

export SUPPORTED_DISTROS=( rhel sles ubuntu )

DISTRO_ID=$(awk 'BEGIN { FS="=" } $1=="ID" { gsub(/"/, "", $2); print $2 }' /etc/os-release)
DISTRO_ID_LIKE=( $(awk 'BEGIN { FS="=" } $1=="ID_LIKE" { gsub(/"/, "", $2); print $2 }' /etc/os-release) )
if [[ " ${SUPPORTED_DISTROS[@]} " == *" DISTRO_ID "* ]]
then
  EFFECTIVE_DISTRO=${DISTRO_ID}
else
  for SIMILAR_DISTRO in "${DISTRO_ID_LIKE[@]}"
  do
    if [[ " ${SUPPORTED_DISTROS[@]} " == *" $SIMILAR_DISTRO "* ]]
    then
      EFFECTIVE_DISTRO=${SIMILAR_DISTRO}
      break
    fi
  done
fi

echo Distro = $DISTRO_ID, effective distro = $EFFECTIVE_DISTRO
if [[ -z ${EFFECTIVE_DISTRO} ]]
then
  echo "unsupported distro ${DISTRO_ID}"
  exit -1
fi
export DISTRO_ID
export EFFECTIVE_DISTRO
