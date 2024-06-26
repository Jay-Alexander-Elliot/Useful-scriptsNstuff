import os
import requests
import logging

class MailgunClient:
    def __init__(self, api_endpoint, api_key, sender_email):
        self.api_endpoint = api_endpoint
        self.api_key = api_key
        self.sender_email = sender_email

    def send_email(self, to, subject, body):
        data = {
            'from': self.sender_email,
            'to': to,
            'subject': subject,
            'text': body
        }

        try:
            response = requests.post(
                self.api_endpoint,
                auth=('api', self.api_key),
                data=data
            )
            if 200 <= response.status_code < 300:
                logging.info('Email sent successfully!')
            else:
                logging.error(f'Failed to send email. Status code: {response.status_code}, Response: {response.text}')
        except requests.RequestException as e:
            logging.error(f'An exception occurred: {e}')

# Example usage
if __name__ == "__main__":
    api_endpoint = os.getenv("MAILGUN_API_ENDPOINT", "https://api.mailgun.net/v3/YOUR_DOMAIN_NAME/messages")
    api_key = os.getenv("MAILGUN_API_KEY", "YOUR_MAILGUN_API_KEY")
    sender_email = os.getenv("SENDER_EMAIL", "YOUR_SENDER_EMAIL")

    client = MailgunClient(api_endpoint, api_key, sender_email)
    to = "RECIPIENT_EMAIL"
    subject = "HI"
    body = "HIT THE LIKE BUTTON"
    
    client.send_email(to, subject, body)
