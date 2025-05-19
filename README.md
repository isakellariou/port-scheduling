# port-scheduling
Preliminary version of a scheduler in a port context.

# Running the scheduler locally
In order to run the scheduler locally, you need to have installed The ECLiPSe Constraint Programming System (ECLiPSe CLP), which can be downloaded from https://eclipseclp.org/.
Once ECLiPSe CLP has been installed, simply compile (load) in the Prolog interpreter the scheduler.ecl file, and type the query
run_port_scheduler.
This will start a http service that accepts JSON requests on port 8080.
Command line execution of the above (once eclipse is installed)
eclipse -f scheduler.ecl -e run_port_scheduler
Request Examples can be found in the folder json_requests and are explained later in this document.



Scheduler implemented in ECLiPSe Prolog.
