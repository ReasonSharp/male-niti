# Male Niti Platform

This project is a platform that builds the entire Male Niti website with all its services and applications.

## Building the platform

To build the entire platform, you need to run some commands and write a couple of configurations:

### Step 1: Prepare the environment

```bash
./mn prepare-env [ENV]
```

Replace `[ENV]` witht the desired environment: `dev`, `test`, `stage` or `prod`.

This will create two files: `env.sh` and `env-[ENV].sh`.

### Step 2: Configure the platform

Now edit the `env-[ENV].sh` file and enter all configuration details.

### Step 3: Build the platform

From here, you can run `./mn up` to bring up the entire platform, or you can bring up individual components.

To bring up individual components manually, first run `./mn write-configs`. This will write configuration files

See `./mn` output for additional commands.

## Stopping the platform

### Keep the volumes (data)

To stop the entire platform, run `./mn down`.

To also remove the environment information, run `./mn down --full`.

### Remove the volumes (data)

To stop the entire platform and erase all volumes (all data), run `./mn down --vol`.

To also remove the environment information, run `./mn down --vol --full`.
