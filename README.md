# Let's Certify

A companion container to a Dockerized web server which uses [Let's Encrypt](https://letsencrypt.org) certificates.

## Usage

Start the `letscertify` container:

```bash
$ docker run -d --name=letscertify anroots/letscertify
```

Configure your web server to accept HTTP queries to `/.well-known/acme-challenge` and use `/tmp/letsencrypt-web` as the document root.

```
# Nginx example. This will redirect all requests to HTTPS except Let's Encrypt certificate challenges
server {
  listen 80;
  server_name api.improv.ee;
  
  location '/.well-known/acme-challenge' {
    default_type "text/plain";
    root /tmp/letsencrypt-web;
  }

  location / {
    return 301 https://$host$request_uri;
  }
}
```

Configure your web server to use Let's Encrypt certificates:

```
# Partial Nginx example
server {
  listen 443 ssl default deferred;
	server_name api.improv.ee;
    
  ssl_certificate /etc/letsencrypt/live/api.improv.ee/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/api.improv.ee/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/api.improv.ee/chain.pem;
}
```

Start your web server and bind volumes from `letscertify`:

```bash
$ docker run -d --volumes-from=letscertify:ro improv/gateway
```

The web server will mount `/etc/letsencrypt`, `/var/lib/letsencrypt` and `/tmp/letsencrypt-web` folders. `letscertify` will
run `letsencrypt renew` daily.

This is designed to auto-renew certificates. You'll still have to manually request initial certificates with something like the following:

```bash
$ docker exec letscertify letsencrypt certonly --webroot -w /tmp/letsencrypt-web/ -d api.improv.ee --agree-tos --email ando@sqroot.eu
```

## License

MIT license