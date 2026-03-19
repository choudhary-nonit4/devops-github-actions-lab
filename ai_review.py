prompt = f"""
You are a senior DevOps engineer.

Analyze this code diff and provide:
1. Code improvements
2. Terraform best practices
3. Security issues (IAM, secrets, etc.)
4. CI/CD improvements
5. Test cases (if applicable)

Be concise and structured.

Diff:
{diff}
"""