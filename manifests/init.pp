# Class: puppet_autosign
# ===========================
#
# Authors
# -------
#
# Author Name mevalke@gmail.com
#
# Copyright
# ---------
#
# Copyright 2017 Miikka Valkeapää, unless otherwise noted.
#
class puppet_autosign {
  case $kernel {
    'Linux': {
      $autosign_content = @(END)
      #!/bin/bash

      CERTNAME=$1
      CSR=/etc/puppetlabs/puppet/ssl/ca/requests/$CERTNAME.pem
      CUSTOM_ATTR=$(openssl req -noout -text -in "$CSR" | grep "challengePassword" | awk -F ":" '{print$2}')
      AUTOSIGN_FOLDER=/opt/puppetlabs/autosign
      AUTOSIGN_FILE=$AUTOSIGN_FOLDER/$CERTNAME

      if [ "$CUSTOM_ATTR" == "$(cat $AUTOSIGN_FILE)" ]; then
        rm $AUTOSIGN_FILE
        exit 0
      else
        rm $AUTOSIGN_FILE
        exit 1
      fi
      | END

      $genpasscode_content = @(END)
      #!/bin/bash

      CERTNAME=$1
      AUTOSIGN_FOLDER=/opt/puppetlabs/autosign
      AUTOSIGN_FILE=$AUTOSIGN_FOLDER/$CERTNAME
      GEN_PASS=$(tr -cd 'a-f0-9' < /dev/urandom | head -c 32)

      if [ ! -e $AUTOSIGN_FOLDER ]; then
        mkdir $AUTOSIGN_FOLDER
      fi

      echo $GEN_PASS >  $AUTOSIGN_FILE

      chown -R puppet:puppet $AUTOSIGN_FOLDER

      cat <<EOF
      Insert this in /etc/puppetlabs/puppet/csr_attributes.yaml:

      custom_attributes:
        1.2.840.113549.1.9.7: $GEN_PASS
      EOF

      exit 0
      | END

      file {'/usr/local/bin/autosign':
        ensure  => file,
        mode    => '755',
        content => inline_epp($autosign_content),
      }

      file {'/usr/local/bin/genpasscode':
        ensure  => file,
        mode    => '755',
        content => inline_epp($genpasscode_content),
      }  
      
      puppetconf::master { 'autosign':
        value => '/usr/local/bin/autosign',
      }
    }      
    default: {
      notify{"Non supported operating system detected: ${::osfamily}":}
    }
  }
}
