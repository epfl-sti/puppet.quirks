# puppet.quirks

Fix quirks in the Puppet installation on supported platforms

# How to use

**This class does nothing in <code>puppet agent</code> mode** (unless
specifically told to). It is intended as a helper for `puppet apply`
and for people who don't know Puppet very well.

If you just want to run the module one-shot:

`puppet apply -e 'class { "quirks": }'`

If you want to embed Quirks in your Puppet module to make it more
friendly to broken (distro-provided) Puppets: add this to
`metadata.json`,

```
    {
      "name": "epflsti/quirks",
      "version_requirement": ">= 0.2.1"
    }
```

And in some manifest:

```
ensure_resource('class', 'quirks')
```
