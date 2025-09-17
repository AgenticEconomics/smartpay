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

"""Subagents module for shopping agent."""

# Import subagents
from . import payment_method_collector
from . import shipping_address_collector
from . import shopper

# Create a simple root_agent for ADK compatibility
class SubagentsContainer:
    """Container for shopping agent subagents."""

    def __init__(self):
        self.subagents = {
            'payment_method_collector': payment_method_collector.payment_method_collector,
            'shipping_address_collector': shipping_address_collector.shipping_address_collector,
            'shopper': shopper.shopper
        }

    def process_request(self, request):
        """Process a request by delegating to appropriate subagent."""
        return {"status": "success", "message": "Subagents container ready"}


# Create the root_agent instance that ADK expects
root_agent = SubagentsContainer()
