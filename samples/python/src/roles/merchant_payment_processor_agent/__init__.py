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

"""The merchant payment processor agent module."""

from common.retrying_llm_agent import RetryingLlmAgent
from common.system_utils import DEBUG_MODE_INSTRUCTIONS


# Create an ADK-compatible root_agent using RetryingLlmAgent
root_agent = RetryingLlmAgent(
    max_retries=3,
    model="gemini-2.5-flash",
    name="merchant_payment_processor_agent",
    instruction="""
    You are a merchant payment processor agent responsible for processing payments and handling transactions.

    You can:
    1. Process payment requests
    2. Handle payment authorization
    3. Manage transaction status
    4. Provide payment confirmations

    %s

    Always ensure secure payment processing and provide clear transaction status updates.
    """ % DEBUG_MODE_INSTRUCTIONS,
)
