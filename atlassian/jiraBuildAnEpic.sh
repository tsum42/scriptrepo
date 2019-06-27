# File: jiraBuildAnEpic.sh
# This script will build an epic based upon a the provided csv file

# include standard modules
import argparse         # used to process arguments
import csv              # used to load the csv file
from jira import JIRA   # used to interace with JIRA

# define the program description
text = 'This script builds out an epic and stories in JIRA based upon the contents of a csv file'


# initiate the parser with a description
parser = argparse.ArgumentParser(description = text)  
parser.add_argument("--project", "-p", help="enter the JIRA project key. example: MVP1")
parser.add_argument("--capability", "-c", help="enter in the name of the capability. example: SCM")
parser.add_argument("--product", "-t", help="enter in the name of the tool or product. example: GitHub")
parser.add_argument("--file", "-f", help="enter in the name of the csv file. example: epic.csv")
args = parser.parse_args()  

# Variables
# TODO Replace with token
server = 'https://mysitename.atlassian.net'
account = 'myemail@email.com'
password = 'mypassword'


epicField = 'customfield_10005'
epicLink = 'customfield_10008' 
projectKey = args.project
capability = args.capability
product = args.product
fileName = args.file

# Load the csv file
with open(fileName) as f:
    reader = csv.DictReader(f)
    data = [r for r in reader] 

# validate that the 1st item on the list is an epic
if data[0]['Issue Type'] != "Epic":
    sys.exit("The first item in " + fileName + " is not identified as an epic")

# Connect to the JIRA Cloud Instance
options = {'server': server}                            # set options
jira = JIRA(options,basic_auth=(account, password))     # a username/password tuple

# loop through all items on the list
for x in range (0, len(data)):
    # swap out placeholder text
    summary = data[x]['Summary']
    summary = summary.replace("<capability>", capability)
    summary = summary.replace("<product>", product)
    description = data[x]['Description']
    description = description.replace("<capability>", capability)
    description = description.replace("<product>", product)

    if x == 0:
        print("creating an epic")
        epic_dict = {
            'project': {'key': projectKey},
            'summary': summary,
            'description': description,
            "issuetype": {"id": "10000"},
            epicField : summary,    
            'labels': [data[x]['Labels']], 
        }
        epic = jira.create_issue(fields=epic_dict)
        print (str(epic) + " created")
        
        #issue = jira.issue('JRA-1330', fields='summary,comment')
    else:
        print("creating a story")
        # issues = jira.create_issues(field_list=issue_list)
        issue_dict = {
            'project': {'key': projectKey},
            'summary': summary,
            'description': description,
            'issuetype': {'name': 'Bug'},  
            'labels': [data[x]['Labels']],
            epicLink : str(epic), 
        }
        issue = jira.create_issue(fields=issue_dict)
        print (str(issue) + " created")
