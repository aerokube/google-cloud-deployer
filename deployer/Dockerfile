ARG MARKETPLACE_TOOLS_TAG
FROM gcr.io/google-appengine/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ARG REGISTRY
ARG TAG
ARG SELENOID_UI_TAG

ADD chart/moon /tmp/chart
RUN cat /tmp/chart/Chart.yaml \
    | env -i "TAG=$TAG" envsubst \
    > /tmp/chart/Chart.yaml.new \
    && mv /tmp/chart/Chart.yaml.new /tmp/chart/Chart.yaml
RUN cd /tmp && tar -czvf /tmp/moon.tar.gz chart

ADD apptest/deployer/moon /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/moon.tar.gz chart/

ADD schema.yaml /tmp/schema.yaml

RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" "SELENOID_UI_TAG=$SELENOID_UI_TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

ADD apptest/deployer/schema.yaml /tmp/apptest/schema.yaml
RUN cat /tmp/apptest/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/apptest/schema.yaml.new \
    && mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm:$MARKETPLACE_TOOLS_TAG
COPY --from=build /tmp/moon.tar.gz /data/chart/
COPY --from=build /tmp/test/moon.tar.gz /data-test/chart/
COPY --from=build /tmp/apptest/schema.yaml /data-test/
COPY --from=build /tmp/schema.yaml /data/

