# encoding: UTF-8

control 'V-242441' do
  title "Kubernetes endpoints must use approved organizational certificate and
key pair to protect information in transit."
  desc  "Kubernetes control plane and external communication is managed by API
Server. The main implementation of the API Server is to manage hardware
resources for pods and container using horizontal or vertical scaling. Anyone
who can gain access to the API Server can effectively control your Kubernetes
architecture. Using authenticity protection, the communication can be protected
against man-in-the-middle attacks/session hijacking and the insertion of false
information into sessions.

    The communication session is protected by utilizing transport encryption
protocols, such as TLS. TLS provides the Kubernetes API Server with a means to
be able to authenticate sessions and encrypt traffic.

    By default, the API Server does not authenticate to the kubelet HTTPs
endpoint. To enable secure communication for API Server, the parameter
-kubelet-client-certificate and kubelet-client-key must be set. This parameter
gives the location of the certificate and key pair used to secure API Server
communication.
  "
  desc  'rationale', ''
  desc  'check', "
    Change to the /etc/kubernetes/manifests/ directory on the Kubernetes Master
Node. Run the command:

    grep -i kubelet-client-certificate *
    grep -I kubelet-client-key *

    If the setting \"--kubelet-client-certificate\" is not configured in the
Kubernetes API server manifest file or contains no value, this is a finding.

    If the setting \"--kubelet-client-key\" is not configured in the Kubernetes
API server manifest file or contains no value, this is a finding.
  "
  desc 'fix', "Edit the Kubernetes API Server manifest file in the
/etc/kubernetes/manifests directory on the Kubernetes Master Node. Set the
value of \"--kubelet-client-certificate\" and \"--kubelet-client-key\" to an
Approved Organizational Certificate and key pair."
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000516-CTR-001325'
  tag gid: 'V-242441'
  tag rid: 'SV-242441r712679_rule'
  tag stig_id: 'CNTR-K8-002640'
  tag fix_id: 'F-45674r712678_fix'
  tag cci: ['CCI-002418']
  tag nist: ['SC-8']

  unless kube_apiserver.exist?
    impact 0.0
    desc 'caveat', 'Kubernetes API Server process is not running on the target.'
  end

  describe kube_apiserver do
    its('kubelet-client-certificate') { should_not be_nil }
    its('kubelet-client-key') { should_not be_nil }
  end
end
