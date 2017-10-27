# Money Tracker
The Money Tracker is an application to track your monthly expenses. It provides a true RESTful HTTP API, which is documented using Spring Rest Docs. The source is shamelessly copied from [dennisstritzke/money-tracker](https://github.com/dennisstritzke/money-tracker).

Visit `http://localhost:8080` to use the application.

Visit `http://localhost:8080/docs/api-guide.html` to view the documentation.

## Run locally
The Money Tracker can be started locally. By default the service will store the data in an in-memory database.
```
mvn package
java -jar target/*.jar
```

Visit [http://localhost:8080](http://localhost:8080).

## Run in Docker
There is also a `docker-compose` file so you can run the service in Docker, which will use a PostgreSQL database as storage backend. We are assuming that [Docker CE](https://www.docker.com/) is installed.

```
docker-compose up -d
```

Logs are available from
```
docker-compose logs -f starter
```

## Run in Altemista Cloud
Finally, we bring the service into the cloud so that real apps can use it in real live. It is assumed that you have set-up your Altemista Toolbelt and are also familiar with some Altemista Basics. If not I recommend our set of /From Zero to Hero/ tutorials which are avail [here](https://tutorial-tutorial.ballpark.altemista.cloud/).

So we start by logging in to the Altemista Cloud. Replace the parameters with the cluster you are using and your login credentials.
```
oc login <cluster>.altemista.cloud:8443 -u "<username>" -p "<password>"
```

Create a new project (with a unique name):
```
oc new-project starter-<your_team_name>
```

Create build credentials so that OpenShift can access Git. Make sure you provide your Git credentials, not the OpenShift credentials.
- If you want to fetch the sources via a username / password combo
  ```
  oc secrets new-basicauth scmsecret --username=<username> --password=<password>
  oc secrets add builder scmsecret
  ```
- If you want to fetch the sources via a privatekey (make sure not to use an existing one)
  ```
  oc secrets new-sshauth scmsecret --ssh-privatekey=<path to privatekey>
  oc secrets add builder scmsecret
  ```

Finally build and deploy the application from the master branch.
```
./createApp.sh starter-<your_team_name> moneytracker https://github.com/Altemista/starter-java.git
```

## Known Vulnerability Scan
Within the pom.xml the OWASP dependency check is added. To execute the dependency scan, execute `mvn dependency-check:aggregate`.
