Demo
====

This project demostrates how to use Aviator.


## Installation

### RVM

The Ruby Version Manager is a great tool for easily managing 
multiple Ruby versions in your machine. Install it with the
following command:

    curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3

**Ubuntu users** If you are using Gnome-terminal, you may need to
set a preference item in your terminal. Please visit [this RVM page](https://rvm.io/integration/gnome-terminal) for more info.

For more information about RVM, please see https://rvm.io/

### Clone This Repo

    git clone git@github.com:aviator/demo.git && cd demo

### Install the dependencies

    bundle install

### Configure Aviator

First, copy the example config file

    cp aviator.yml.example aviator.yml

Edit the following in `aviator.yml`:

* `host_uri` - Should point to a valid keystone API
* `username` - A valid username that exists in <host_uri>
* `password` - The user's password
* `tenantName` - Tenant/project where the user has a role. Preferably one where the user has an admin role so that you can also access admin enpoints in some of the demo files.
    

### Run the sample files

    demo/<filename with extension>
    

## More info

For more info on Aviator, please visit http://aviator.github.io/www
