set -e

usage() {
  echo "
usage: $0 <options>
  Required not-so-options:
     --build-dir=DIR             path to presto dist.dir
     --prefix=PREFIX             path to install into
  "
  exit 1
}

OPTS=$(getopt \
    -n $0 \
    -o '' \
    -l 'build-dir:' \
    -l 'prefix:' \
    -l 'doc-dir:' \
    -- "$@")


if [ $? != 0 ] ; then
  usage
fi

eval set -- "$OPTS"
while true ; do
  case "$1" in
    --build-dir)
    BUILD_DIR=$2 ; shift 2
    ;;
    --prefix)
    PREFIX=$2 ; shift 2
    ;;
    --doc-dir)
    DOC_DIR=$2 ; shift 2
    ;;
    --)
    shift ; break
    ;;
    *)
    echo "Unknown option: $1"
    usage
    exit 1                                   
;;
  esac
done

for var in PREFIX BUILD_DIR ; do
  if [ -z "$(eval "echo \$var")" ]; then
    echo Missing param: $var
    usage
  fi
done


PRESTO_HOME=${PRESTO_HOME:-/usr/lib/presto}
ETC_DIR=${ETC_DIR:-/etc/presto}
DOC_DIR=${DOC_DIR:-/usr/share/doc/presto-doc}

# Create the required directories.
install -d -m 0755 ${PREFIX}/$PRESTO_HOME
install -d -m 0755 ${PREFIX}/$ETC_DIR
install -d -m 0755 ${PREFIX}/$DOC_DIR
install -d -m 0755 ${PREFIX}/var/{log,run}/presto


# Copy artifacts to the appropriate Linux locations.
cp -ra ${BUILD_DIR}/presto* ${PREFIX}/usr/lib/presto

