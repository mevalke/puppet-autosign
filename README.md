# puppet_autosign

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with puppet_autosign](#setup)
    * [What puppet_autosign affects](#what-puppet_autosign-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet_autosign](#beginning-with-puppet_autosign)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module sets up Puppet Master for autosigning certificate requests.

## Setup

### What puppet_autosign affects 

The module makes sure the following two files exist in /usr/local/bin on the target node:

* autosign: This file expects a certname as input. It also expects a file named after the certname to be found in /opt/puppetlabs/autosign. This file should contain a custom_attributes definition for a one time passcode. The script then checks if a crl containing a matching passcode exists in etc/puppetlabs/puppet/ssl/ca/requests/. If yes, it exits with 0 and the crl is signed. If no, it exits with 1 and the crl gets rejected. In either case the file containing the one time passcode is removed.

* genpasscode: This file generates the custom_attributes definition and prints it to stdout along with instructions of where to insert it.

### Setup Requirements 

Install the cjtoolseram/puppetconf module.

```
puppet module install cjtoolseram-puppetconf --version 0.2.7
```

## Usage

Include the module.

```
include puppet_autosign
```

On Puppet Server generate a passcode.

```
/usr/local/bin/genpasscode server.example.com
Insert this in /etc/puppetlabs/puppet/csr_attributes.yaml:

custom_attributes:
  1.2.840.113549.1.9.7: 9caa0f7a766994e5c15830817f151b24
```

Then on the agent create the csr_attributes file and insert the output of the genpasscode command.

## Development

Any form of contribution is welcomed.

## Release Notes

0.1.0: First release
