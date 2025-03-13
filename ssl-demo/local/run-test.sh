LGREEN='\033[1;32m'
LRED='\033[0;31m'
NC='\033[0m' # No Color

APP_HOST=${LOCAL_STACK}:8061
CAPULET_HOST=${LOCAL_STACK}:19443
MONTAGUE_HOST=${LOCAL_STACK}:10443

echo "${LGREEN}Requesting Capulet from SSL Demo${NC}"
curl \
  --request GET \
  --cert ./montague/tybalt/tybalt.crt \
  --key ./montague/tybalt/tybalt.key \
  --cacert ./montague/montague.crt \
  https://${APP_HOST}/capulet
echo ""

echo "${LGREEN}Requesting Montague from SSL Demo${NC}"
curl \
  --request GET \
  --cert ./montague/tybalt/tybalt.crt \
  --key ./montague/tybalt/tybalt.key \
  --cacert ./montague/montague.crt \
  https://${APP_HOST}/montague
echo ""

echo "${LGREEN}Requesting Capulet from NGINX${NC}"
curl \
  --request GET \
  --cert ./capulet/the-nurse/the-nurse.crt \
  --key ./capulet/the-nurse/the-nurse.key \
  --cacert ./capulet/capulet.crt \
  https://${CAPULET_HOST}
echo ""

echo "${LRED}Requesting Capulet from NGINX without client cert${NC}"
curl \
  --request GET \
  --cacert ./capulet/capulet.crt \
  https://${CAPULET_HOST}
echo ""

echo "${LGREEN}Requesting Montague from NGINX${NC}"
curl \
  --request GET \
  --cacert ./montague/montague.crt \
  https://${MONTAGUE_HOST}
echo ""
