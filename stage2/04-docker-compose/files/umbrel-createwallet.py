#!/usr/bin/env python3

'''
Copyright © 2018-2019 LNCM Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Documented logic

1. Check if theres already a wallet. If there is, then exit.
2. Check for sesame.txt
3. If doesn't exist then check for whether we should save the password (save_password_control_file exists) or not
4. If sesame.txt exists import password in.
5. If sesame.txt doesn't exist ans we don't save the password,create a password and save it in temporary path as defined in temp_password_file_path
6. Now start the wallet creation. Look for a seed defined in seed_filename , if not existing then generate a wallet based on the seed by LND.

'''
import base64, codecs, json, requests, os
import random, string

# Generate seed
url = 'https://localhost:8080/v1/genseed'
# Initialize wallet
url2 = 'https://localhost:8080/v1/initwallet'
cert_path = '/home/umbrel/lnd/tls.cert'
seed_filename  = '/home/umbrel/secrets/seed.txt' 

# save password control file (Add this file if we want to save passwords)
save_password_control_file = '/home/umbrel/.save_password'
# Create password for writing
temp_password_file_path = '/tmp/.password.txt'

''' 
  Functions have 2 spaces
'''
def randompass(stringLength=10):
  letters = string.ascii_letters
  return ''.join(random.choice(letters) for i in range(stringLength))

def main():
  if not os.path.exists(save_password_control_file):
    # Generate password but dont save it in usual spot
    password_str=randompass(stringLength=15)
    temp_password_file = open(temp_password_file_path, "w")
  # Check if there is an existing file, if not generate a random password
  if not os.path.exists("/home/umbrel/secrets/lnd-password.txt"):
    # sesame file doesnt exist
    password_str=randompass(stringLength=15)
    if not os.path.exists(save_password_control_file):
      # Use tempory file if there is a password control file there
      temp_password_file = open(temp_password_file_path, "w")
      temp_password_file.write(password_str)
      temp_password_file.close()
    else:
      # Use sesame.txt if password_control_file exists
      password_file = open("/home/umbrel/secrets/lnd-password.txt","w")
      password_file.write(password_str)
      password_file.close()
  else:
    # Get password from file if sesame file already exists
    password_str = open('/home/umbrel/secrets/lnd-password.txt', 'r').read().rstrip()

  # Convert password to byte encoded
  password_bytes = str(password_str).encode('utf-8')
  # Step 1 get seed from web or file

  # Send request to generate seed if seed file doesnt exist
  if not os.path.exists(seed_filename):
    r = requests.get(url, verify=cert_path)
    if r.status_code == 200:
      json_seed_creation = r.json()
      json_seed_mnemonic = json_seed_creation['cipher_seed_mnemonic']
      json_enciphered_seed = json_seed_creation['enciphered_seed']
      seed_file = open(seed_filename, "w")
      for word in json_seed_mnemonic:
        seed_file.write(word + "\n")
      seed_file.close()
      data = { 'cipher_seed_mnemonic': json_seed_mnemonic, 'wallet_password': base64.b64encode(password_bytes).decode()}
    # Data doesnt get set if cant create the seed but that is fine, handle it later
  else:
    # Seed exists
    seed_file = open(seed_filename, "r")
    seed_file_words = seed_file.readlines()
    import_file_array = []
    for importword in seed_file_words:
      import_file_array.append(importword.replace("\n", ""))
    # Generate init wallet file from what was posted
    data = { 'cipher_seed_mnemonic': import_file_array, 'wallet_password': base64.b64encode(password_bytes).decode()}
  
  # Step 2: Create wallet
  try:
    data
  except NameError:
    print("data isn't defined")
    pass
  else:
    # Data is defined so proceed
    r2 = requests.post(url2, verify=cert_path, data=json.dumps(data))
    if r2.status_code == 200:
      # If create wallet was successful
      print("Create wallet is successful")
    else:
      print("Create wallet is not successful")


'''
Main entrypoint function

Testing creation notes:
rm /home/lncm/seed.txt
rm /media/important/important/lnd/sesame.txt

docker stop compose_lndbox_1 ; rm -fr /media/important/important/lnd/data/chain/ ; docker start compose_lndbox_1
'''

if __name__ == '__main__':
  if os.path.exists("/home/umbrel/lnd"):
    if not os.path.exists("/home/umbrel/lnd/data/chain/bitcoin/mainnet/wallet.db"):
      main()
    else:
      print('Wallet already exists! Please delete .lnd/data/chain and then restart LND')
  else:
    print('LND directory does not exist!')


