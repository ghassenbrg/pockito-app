# Local cluster validation

Proves the manifests in `infra/k8s/` actually work, before they are applied anywhere that
matters. This is not a deployment — it is a test harness for one.

```bash
./up.sh        # kind cluster + Traefik + the real manifests
./verify.sh    # 25 checks
```

`up.sh` applies the manifests from `infra/k8s/` unmodified. Only two things are overridden,
because neither can point at production from a laptop:

| File                       | Overrides                                                        |
|----------------------------|------------------------------------------------------------------|
| `overlay.yaml`             | Keycloak endpoints — issuer as the client sees it, JWKS as the cluster can fetch it |
| `old-compat-upstream.yaml` | The `/old` proxy's upstream: the public legacy site instead of an in-cluster pod   |
| `old-target.yaml`          | An ExternalName standing in for the legacy service                |
| `dify-stub.yaml`           | A stub at Dify's exact in-cluster address and probe contract       |
| `traefik.yaml`             | Traefik itself, which the real cluster already runs               |

`verify.sh` checks workload readiness, PVC binding, every Traefik route, the `/old` rewrite
chain asset by asset, and that data written to object storage survives deleting its pod.

Two real defects were found this way: the SeaweedFS identity could not create its own
bucket, and the redirect middlewares were anchored to a literal hostname so they stopped
matching on any other host or port.
