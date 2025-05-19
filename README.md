# port-scheduling
Preliminary version of a scheduler in a port context.
(Under Construction)

# Running the scheduler locally
In order to run the scheduler locally, you need to have installed The ECLiPSe Constraint Programming System (ECLiPSe CLP), which can be downloaded from https://eclipseclp.org/.
Once ECLiPSe CLP has been installed, simply compile (load) in the Prolog interpreter the scheduler.ecl file, and type the query

```run_port_scheduler.```

This will start a http service that accepts JSON requests on port 8080.
Command line execution of the above (once eclipse is installed)

```eclipse -f scheduler.ecl -e run_port_scheduler ```

Request Examples can be found in the folder json_requests and are explained later in this document.

# Building the docker image of the Scheduler (only)
As usual, run 

``` docker build -t <your image name> . ```

The Dockerfile will automatically download the ECLiPSe runtime engine.

and then start the container 

``` docker run -p 8080:8080 <your image name> ```

to start the service. 

# Using the TSN Scheduler
The current implementation, supports schedule generation in the form of a http JSON requests, that describe the requirements, in terms of trucks and delivery targets.
Example of a Json Request
```json
  {
    "trucks":2,
    "reach_stacker_at":"C22",
    "containers": [
        {
            "id": 1,
            "service_type": "STUFF",
            "warehouse": "Z32C",
            "type": "KO"
        },
        {
            "id": 2,
            "service_type": "STUFF",
            "warehouse": "Z13B",
            "type": "KO"
        },
        {
            "id": 3,
            "service_type": "STRIP",
            "warehouse": "Z33D",
            "type": "ZA"
        },
        {
            "id": 4,
            "service_type": "STRIP",
            "warehouse": "Z51A",
            "type": "ZA"
        },
        {
            "id": 5,
            "service_type": "STRIP",
            "warehouse": "Z33B",
            "type": "KO"
        }
    ]
}
```

"Trucks:" is the number of trucks available (if missing then we assume 5 trucks), "reach_stacker:" is teh position of the reach stacker and "containers:" is a list of containers with service type and destination. The "reach_stacker:" is ignored in cases of forming the daily plan, however it is *necessary* in cases of replanning (see below).


## Invoking the Scheduler

The scheduler can generate output, either targeting a daily plan or a replan. 

### daily schedule
Interacting with the scheduler obtaining a solution for the deliveries of the day, is invoked via the API path:

```
GET http://<host>:<port>/port_schedule/daily
```

with payload the JSON request file, described above. 

For instance, assume that the scheduler is running in the local host, on port 8080 and the JSON file that contains the request is "test5.json", the corresponding curl command is:
```
curl -v -X GET -H "Content-Type: application/json" --data @test5.json http://localhost:8080/port_schedule/daily
``` 

In this case, the answer is in the form of JSON, contains the path of the reach stacker and the assignments to trucks.


### replan

In some cases, the scheduler needs to replan the deliveries for some reason during the execution of the plan. In this case, the position of reach stacker is necessary along with any information on the undelivered containers. In this case the api path is 

```
GET http://<host>:<port>/port_schedule/replan
```
with payload a JSON file that necessarily contains the reach stacker position.

For instance run:

```
curl -v -X GET -H "Content-Type: application/json" --data @test5.json http://localhost:8080/port_schedule/replan
``` 

and observe that a different schedule is generated. 

### Health Check

In order to check whether the scheduler is ready (upon initialization) use the API path:

```
GET http://<host>:<port>/port_schedule/health
```

This is very useful, when using the container as a side car. 



# Final Note
Scheduler implemented in ECLiPSe Prolog.
