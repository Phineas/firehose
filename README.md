# Firehose

Firehose is an example of how you can use [SSE](https://github.com/mustafaturan/sse) and Redis (redix) to push events from Redis Pub/Sub to a server-sent events HTTP stream using Elixir with deployment using distillery. (+ configs on how you can easily deploy to Kubernetes!)

## Breakdown

#### lib/firehose.ex
Plug router, implementing `Plug.Router`, sets up a `/pipe` route which is the main entry point for SSE. It streams events coming from the EventBus channel as described below. It also sets up a `/infra/nodes` route which lists the nodes on the Erlang cluster for debugging, if running in cluster mode

#### lib/redis_eventbus.ex
GenServer which subscribes to a Redis channel, then on Pub/Sub message recieve, it assumes the message is in JSON format, then tries to deserialize the string into JSON using Poison. It then sends the message to an [EventBus](https://github.com/otobus/event_bus).

#### supervisor.ex
General-purpose supervisor for setting up Plug and starting the Redis listener.

## Deployment configs

#### config/prod.exs
Configures SSE, EventBus, and [https://github.com/bitwalker/libcluster](libcluster) for production using the Kubernetes strategy. Polls the K8s API every 10 seconds for nodes using the selector `app=firehose`.

#### firehose-deployment.yml
Kubernetes deployment configuration file which fetches a docker image and sets envoronment variables for the port Plug will serve on, and variables that libcluster requires. It also sets Erlang cluster variables, such as the cookie so the nodes in the clusters can communicate if needed.

#### firehose-ingress.yml
Sets up a Kubernetes ingress which finds Firehose instances and serves them on port 80.

#### kube-gcp-roles.yml
Deploys roles on Kubernetes using rbac.authorization which gives the Firehose nodes access and permissions to use the in-cluster Kuberenetes API, which libcluster uses to find other nodes in the Kubernetes cluster, and adds it to the Erlang cluster.

#### vm.args
Sets BEAM virtual machine arguments used for Erlang clustering, it takes environment variables as set within the Kubernetes deployment file.

#### Dockerfile
Builds Distillery release and builds Erlang VM bytecode, then exposes port 8080 for Plug and runs the compiled program.