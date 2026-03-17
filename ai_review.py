import os

key = os.environ.get("OPENAI_API_KEY")

# Read diff
with open("diff.txt", "r") as f:
    diff = f.read()

# If no real key → skip gracefully
if not key or key == "dummy-key":
    output = "⚠️ AI Review Skipped: No valid OpenAI API key configured."
else:
    from openai import OpenAI

    client = OpenAI(api_key=key)

    response = client.chat.completions.create(
        model="gpt-4.1",
        messages=[
            {"role": "system", "content": "You are a senior DevOps engineer reviewing code."},
            {"role": "user", "content": f"Review this code diff and suggest improvements and test cases:\n{diff}"}
        ]
    )

    output = response.choices[0].message.content

# Save output
with open("ai_output.txt", "w") as f:
    f.write(output)

print(output)