syntax match sshknownhostspubkey "AAAA[0-9a-zA-Z+/]\+[=]\{0,2}"
highlight def link sshknownhostspubkey Special

syntax match sshalg "\<\(ssh-dss\|ssh-rsa\|ecdsa-sha2-nistp256\|ecdsa-sha2-nistp384\|ecdsa-sha2-nistp521\|ssh-ed25519\)\>"
hi def link sshalg Identifier

syntax match sshknownhostsip "\<\(\d\{1,3}\.\)\{3}\d\{1,3}\>"
hi def link sshknownhostsip Constant
