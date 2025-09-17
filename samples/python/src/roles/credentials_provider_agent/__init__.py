# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""The credentials provider agent module."""

from common.retrying_llm_agent import RetryingLlmAgent
from common.system_utils import DEBUG_MODE_INSTRUCTIONS


# Create an ADK-compatible root_agent using RetryingLlmAgent
root_agent = RetryingLlmAgent(
    max_retries=3,
    model="gemini-2.5-flash",
    name="credentials_provider_agent",
    instruction="""
    You are a credentials provider agent responsible for managing user payment methods and credentials.

    You can:
    1. List available payment methods for users
    2. Provide secure payment tokens
    3. Handle payment authorization
    4. Manage user payment preferences

    %s

    Always prioritize security and user privacy when handling payment credentials.
    """ % DEBUG_MODE_INSTRUCTIONS,
)
