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

* Clients must be started manually or via /etc/network/interfaces

.. code::

    auto eth1
    iface eth1 inet manual
      post-up pon connection1
      pre-down poff connection1
