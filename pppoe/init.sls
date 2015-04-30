# This state installs the pppoe server and client and configures them.
# It also installs the cronjob for a regurarly reconnect time.

{% from "pppoe/map.jinja" import map with context %}

# Install packages
pppoe_server_pkgs:
  pkg.installed:
    - pkgs:
        {% for pkg in map.pkgs %}
        - {{ pkg }}
        {% endfor %}  

# Check if a server config is porvided in pillar
{% if pillar.pppoe is defined and pillar.pppoe.server is defined %}

# Deploy server config file
pppoe_server_config:
  file.managed:
    - name: {{ map.conf_dir }}/pppoe-server-options
    - contents: |
        debug dump
        plugin rp-pppoe.so
        require-pap
        mtu 1492
        mru 1492
        ktune
        proxyarp
        lcp-echo-interval {{ salt['pillar.get']('pppoe:lcp_echo_interval', 30) }}
        lcp-echo-failure {{ salt['pillar.get']('pppoe:lcp_echo_failure', 0) }}        
        nobsdcomp
        noccp
        novj
        noipx

  {% for name, data in salt['pillar.get']('pppoe:server:users', {}).iteritems() %}
# Add credentials
pppoe_credentials_file:
  file.append:
    - name: {{ map.conf_dir }}/pap-secrets
    - text: '"{{ name }}" * "{{ data.pass }}" *'  
  {% endfor %}

{% endif %}

# Check if a client config is porvided in pillar
{% if salt['pillar.get']('pppoe:client', False) %}

# Deploy config file
  {% for name, data in salt['pillar.get']('pppoe:client', {}).iteritems() %}
pppoe_client_config_{{ name }}:
  file.managed:
    - name: {{ map.conf_dir }}/peers/{{ name }}
    - contents: |
        plugin rp-pppoe.so
        {{ data.interface }}
        name "{{ data.user }}"
        ##usepeerdns
        persist
        #demand
        #idle 180
        ##defaultroute
        hide-password
        noauth
        maxfail {{ salt['pillar.get']('pppoe:maxfail', 0) }}        

# Add credentials
pppoe_credentials_file:
  file.append:
    - name: {{ map.conf_dir }}/pap-secrets
    - text: '"{{ data.user }}" * "{{ data.pass }}" *'  
  {% endfor %}

{% endif %}


# This is used for server and client
pppoe_options:
  file.managed:
    - name: /etc/ppp/options
    - contents: |
        asyncmap 0
        crtscts
        lock
        modem
        proxyarp
        lcp-echo-interval {{ salt['pillar.get']('pppoe:lcp_echo_interval', 30) }}
        lcp-echo-failure {{ salt['pillar.get']('pppoe:lcp_echo_failure', 0) }}        
        debug dump
