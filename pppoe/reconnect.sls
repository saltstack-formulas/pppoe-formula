{%- for name, data in salt['pillar.get']('pppoe:client').iteritems() %}

{%-   if data.reconnect is defined %}

{%- set hour = data.reconnect.get('hour', 5) %}
{%- set minute = data.reconnect.get('minute', 0) %}

pppoe_reconnect_{{ loop.index }}:
  file.managed:
    - name: /etc/cron.d/client-{{ name }}
    - contents: |
        {{ minute }} {{ hour }} * * * root /usr/bin/poff {{ name }} && /usr/bin/pon {{ name }}

{%-   endif %}

{%- endfor %}
