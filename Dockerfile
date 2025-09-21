# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

FROM krakend:2.10.2

LABEL version="0.2.0"
LABEL org.opencontainers.image.description="Krakend API Gateway transforms the Combodo iTop RPC-style API into a RESTful API."
LABEL org.opencontainers.image.source="https://github.com/knowitop/itop-api-gw"

ENV KRAKEND_NAME="iTop REST API Gateway" \
    USAGE_DISABLE=1 \
    FC_ENABLE=1 \
    FC_OUT=/etc/krakend/out/krakend.out.json \
    FC_PARTIALS=/etc/krakend/config/partials \
    FC_SETTINGS=/etc/krakend/config/settings \
    FC_TEMPLATES=/etc/krakend/config/templates

COPY krakend .

CMD [ "run", "-c", "/etc/krakend/krakend.json.tmpl" ]

ENV ITOP_HOSTS="" \
    ITOP_BASE_PATH="" \
    ITOP_API_COMMENT="$KRAKEND_NAME" \
    ITOP_AUTH_MODE=token \
    ITOP_AUTH_TOKEN="" \
    ITOP_AUTH_USER="" \
    ITOP_AUTH_PWD="" \
    ALLOW_COOKIE_HEADERS=0 \
    CORS_ALLOW_ORIGINS=""
