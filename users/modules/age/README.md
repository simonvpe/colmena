# Howto

1. On each of you computers and user accounts, generate a new ssh keypair without passphrase. These keys are to be considered ephemeral, since if you lose one set you will still be able to use one of your other machines keys to recover the encrypted content. Let's say these keys are called ~/.ssh/id_ed25519 and ~/.ssh/id_ed25519.pub.

  Each user will now have one public and one private key for every host. In the home manager configuration for each user set the `age.sshKeyPaths` to include the locations on disk where your keys are stored. For the sake of demonstration, assume you generated your private keys to ~/.ssh/id_ed25519 on all your hosts.

2. Configure age
