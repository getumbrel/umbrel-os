#!/usr/bin/env python3

import base64, codecs, json, requests
url = 'https://localhost:8080/v1/unlockwallet'
cert_path = '/home/umbrel/lnd/tls.cert'
password_str = open('/home/umbrel/secrets/lnd-password.txt', 'r').read().rstrip()
password_bytes = str(password_str).encode('utf-8')
data = {
        'wallet_password': base64.b64encode(password_bytes).decode(),
    }


def main():
  try:
    r = requests.post(url, verify=cert_path, data=json.dumps(data))
  except:
    # Silence connection errors when lnd is not running
    pass
  else:
    try:
        print(r.json())
    except:
        # JSON will fail to decode when unlocked already since response is empty
        pass


if __name__ == '__main__':
    main()
