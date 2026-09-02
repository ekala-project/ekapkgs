{
  lib,
  stdenv,
  curl ? null,
  hiredis ? null,
  iptables ? null,
  jdk ? null,
  libatasmart ? null,
  libdbi ? null,
  libesmtp ? null,
  libgcrypt ? null,
  libmemcached ? null,
  cyrus_sasl ? null,
  libmodbus ? null,
  libmicrohttpd ? null,
  libmnl ? null,
  libmysqlclient ? null,
  libnotify ? null,
  gdk-pixbuf ? null,
  liboping ? null,
  libpcap ? null,
  libpq ? null,
  libsigrok ? null,
  libvirt ? null,
  libxml2 ? null,
  lua ? null,
  lvm2 ? null,
  lm_sensors ? null,
  mongoc ? null,
  mosquitto ? null,
  net-snmp ? null,
  openldap ? null,
  openipmi ? null,
  perl ? null,
  protobufc ? null,
  python3 ? null,
  rabbitmq-c ? null,
  rdkafka ? null,
  riemann_c_client ? null,
  rrdtool ? null,
  udev ? null,
  varnish ? null,
  yajl ? null,
  enabledPlugins ? null,
}:

let
  optList = cond: list: if cond then list else [ ];
  opt = v: if v != null then [ v ] else [ ];

  plugins = {
    amqp.buildInputs = (opt yajl) ++ lib.optionals stdenv.hostPlatform.isLinux (opt rabbitmq-c);
    apache.buildInputs = opt curl;
    ascent.buildInputs = (opt curl) ++ (opt libxml2);
    bind.buildInputs = (opt curl) ++ (opt libxml2);
    ceph.buildInputs = opt yajl;
    curl.buildInputs = opt curl;
    curl_json.buildInputs = (opt curl) ++ (opt yajl);
    curl_xml.buildInputs = (opt curl) ++ (opt libxml2);
    dbi.buildInputs = opt libdbi;
    disk.buildInputs = lib.optionals stdenv.hostPlatform.isLinux (opt udev);
    dns.buildInputs = opt libpcap;
    ipmi.buildInputs = opt openipmi;
    iptables.buildInputs =
      (opt libpcap) ++ lib.optionals stdenv.hostPlatform.isLinux ((opt iptables) ++ (opt libmnl));
    java.buildInputs = (opt jdk) ++ (opt libgcrypt) ++ (opt libxml2);
    log_logstash.buildInputs = opt yajl;
    lua.buildInputs = opt lua;
    memcachec.buildInputs = (opt libmemcached) ++ (opt cyrus_sasl);
    modbus.buildInputs = lib.optionals stdenv.hostPlatform.isLinux (opt libmodbus);
    mqtt.buildInputs = opt mosquitto;
    mysql.buildInputs = opt libmysqlclient;
    netlink.buildInputs = (opt libpcap) ++ lib.optionals stdenv.hostPlatform.isLinux (opt libmnl);
    network.buildInputs = opt libgcrypt;
    nginx.buildInputs = opt curl;
    notify_desktop.buildInputs = (opt libnotify) ++ (opt gdk-pixbuf);
    notify_email.buildInputs = opt libesmtp;
    openldap.buildInputs = opt openldap;
    ovs_events.buildInputs = opt yajl;
    ovs_stats.buildInputs = opt yajl;
    perl.buildInputs = opt perl;
    pinba.buildInputs = opt protobufc;
    ping.buildInputs = opt liboping;
    postgresql.buildInputs = opt libpq;
    python.buildInputs = opt python3;
    redis.buildInputs = opt hiredis;
    rrdcached.buildInputs = (opt rrdtool) ++ (opt libxml2);
    rrdtool.buildInputs = (opt rrdtool) ++ (opt libxml2);
    sensors.buildInputs = lib.optionals stdenv.hostPlatform.isLinux (opt lm_sensors);
    sigrok.buildInputs = lib.optionals stdenv.hostPlatform.isLinux ((opt libsigrok) ++ (opt udev));
    smart.buildInputs = lib.optionals stdenv.hostPlatform.isLinux ((opt libatasmart) ++ (opt udev));
    snmp.buildInputs = lib.optionals stdenv.hostPlatform.isLinux (opt net-snmp);
    snmp_agent.buildInputs = lib.optionals stdenv.hostPlatform.isLinux (opt net-snmp);
    varnish.buildInputs = (opt curl) ++ (opt varnish);
    virt.buildInputs =
      (opt libvirt)
      ++ (opt libxml2)
      ++ (opt yajl)
      ++ lib.optionals stdenv.hostPlatform.isLinux ((opt lvm2) ++ (opt udev));
    write_http.buildInputs = (opt curl) ++ (opt yajl);
    write_kafka.buildInputs = (opt yajl) ++ (opt rdkafka);
    write_log.buildInputs = opt yajl;
    write_mongodb.buildInputs = opt mongoc;
    write_prometheus.buildInputs = (opt protobufc) ++ (opt libmicrohttpd);
    write_redis.buildInputs = opt hiredis;
    write_riemann.buildInputs = (opt protobufc) ++ (opt riemann_c_client);
  };

  configureFlags = lib.optionals (enabledPlugins != null) (
    [ "--disable-all-plugins" ] ++ (map (plugin: "--enable-${plugin}") enabledPlugins)
  );

  pluginBuildInputs =
    plugin:
    lib.optionals (
      plugins ? ${plugin} && plugins.${plugin} ? buildInputs
    ) plugins.${plugin}.buildInputs;

  buildInputs =
    if enabledPlugins == null then
      builtins.concatMap pluginBuildInputs (builtins.attrNames plugins)
    else
      builtins.concatMap pluginBuildInputs enabledPlugins;
in
{
  inherit configureFlags buildInputs;
}
