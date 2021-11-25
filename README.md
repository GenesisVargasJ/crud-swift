## CRUD iOS example app

This Swift example app shows how to connect to rest api to do basic CRUD functions.

![alt text](https://www.genesisvargasj.com/assets/img/crud2.png)

### Dependencies:

- Alamofire
- SwiftyJSON

## Configuration

Step 1: Go to Crud Example/Utils folder

Step 2: Edit Constants.swift file and change your url of the node.js api like this
```
static let VERIFY_URL = "http://<YOUR_IP>:3000/api/v1/login"
static let PERSONS_URL = "http://<YOUR_IP>:3000/api/v1/persons"
static let PROFESSIONS_URL = "http://<YOUR_IP>:3000/api/v1/professions"
static let CITIES_URL = "http://<YOUR_IP>:3000/api/v1/cities"
```

## Installation

Follow the steps for app test

Step 1: Clone this repo

Step 2: Open shell window and navigate to project folder

Step 3: Run command
```bash
pod install
```
Step 4: Open `Crud Example.xcworkspace` and run the project on selected device or simulator
