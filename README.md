# SSL Demo

This application seeks to demonstrate the minimum setup required to create a Spring Boot
application, hosted using SSL, which in itself makes calls out to two other
web servers, each hosted on an instance of nginx with a distinct chain of trust.

This project will demonstrate the following
* Using SSL bundles with Rest Client
* Using SSL to secure a spring boot application
* Securing NGINX with SSL
* Requiring Mutual SSL auth in: 
  * Spring Boot
  * nginx

## Running the App
The Makefile provides the means to run the application up.

```bash
make run-docker
```

If you wish to run the application outside of Docker, you can use the following
```bash
make run-bootrun
```

or use the following, and then run ./gradle bootrun yourself.

```bash
make run-nginx
```

Once the application is running, you can test it with this target.
```bash
make run-test
```

## Testing via Firefox
To test the application in Firefox, you will need to import the following under
Settings -> Certificates
The passwords for the p12 files are both `changeit`

* Your Certificates
  * local/montague/tybalt/tybalt.p12
    * required to visit the SSL demo wrapper app
  * local/capulet/the-nurse/the-nurse.p12
    * required to make direct visits to the Capulet NGINX
* Authorities
  * local/montague/montague.crt
    * Required to visit the SSL demo wrapper app
    * Required to visit the Montague NGINX
  * local/capulet/capulet.crt 
    * Required to visit the Capulet NGINX

It should then be possible to visit
* https://localhost:8061/capulet **
* https://localhost:8061/montague **
* https://localhost:10443
* https://localhost:19443 **

`**` Firefox will require you to present a cert

## Unit Testing

This project also demonstrates the use of test containers and wiremock for 
setting up external dependencies.

To run the tests, you can use the usual gradle task

```bash
./gradlew test
```

## Regenerating files
The following command can be used to regenerate all the certs and keys

```bash
make run-test
```

Note that if you do this, anything imported into Firefox will now be invalid.

# Messaging Demo

Under `local/messaging` there are files for demonstrating sending encrypted messages 
using asymmetrical encryption for
* Encryption & Decryption
* Signing & Verification

See the README there for details.