# puppet.quirks

Fix quirks in the Puppet installation on supported platforms

# How to use

In your Puppet module's `metadata.json`:

```
    {
      "name": "epflsti-quirks",
      "version_requirement": ">= 0.0.0"
    }
```

Somewhere in your Puppet code:

```
ensure_resource('class', 'quirks')
```
