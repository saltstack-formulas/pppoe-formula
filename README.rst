=====
pppoe
=====

Formula to install and configure pppoe server and client.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``pppoe``
--------

Installs and configures pppoe server and/or client

Example
=======

1. Create pillar: see *ddns-client/pillar.example* for more details.

2. Run state.highstate

3. Start pppoe server

.. code::

    ifconfig eth1 up && pppoe-server -I eth1

4. Run client

.. code::

    pon connection1

Notes
=====

* Pppoe interfaces must be up and unconfigured.

.. code::

    auto eth1
    iface eth1 inet manual

* Server must be started manually or e.g. via /etc/rc.local

.. code::

    pppoe-server -I eth1

* Clients can be started manually or via /etc/network/interfaces (see https://wiki.debian.org/PPPoE).

.. code::

    auto eth0
    iface eth0 inet manual

    auto dsl-provider
    iface dsl-provider inet ppp
    pre-up    /sbin/ifconfig eth0 up
    provider dsl-provider

* More advanced network config using vlan:


.. code::

    auto eth2
    
    iface eth2 inet manual
      pre-up /sbin/ifconfig eth2 up
      post-down /sbin/ifconfig eth2 down
      post-up /sbin/ifup vlan6
      pre-down /sbin/ifdown vlan6
    
    # vlan6
    # VDSL VLAN 6
    #
    
    iface vlan6 inet manual
      vlan-raw-device eth2
      post-up /sbin/ifconfig vlan6 up
      pre-down /sbin/ifconfig vlan6 down
      post-up /sbin/ifup wan
      pre-down /sbin/ifdown wan
    
    # wan
    # PPPoe MyProvider
    #
    
    iface wan inet ppp
      provider myprovider


