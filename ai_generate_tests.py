import os

key = os.environ.get("OPENAI_API_KEY")

if not key or key == "dummy-key":
    print("Skipping test generation")
    exit(0)

from openai import OpenAI
client = OpenAI(api_key=key)

with open("app.py", "r") as f:
    code = f.read()

response = client.chat.completions.create(
    model="gpt-4.1",
    messages=[
        {"role": "system", "content": "You are a Python testing expert."},
        {"role": "user", "content": f"Generate pytest test cases for this code:\n{code}"}
    ]
)

tests = response.choices[0].message.content

with open("test_app.py", "w") as f:
    f.write(tests)