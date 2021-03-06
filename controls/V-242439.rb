# encoding: UTF-8

control 'V-242439' do
  title "Kubernetes API Server must disable basic authentication to protect
information in transit."
  desc  "Kubernetes basic authentication sends and receives request containing
username, uid, groups, and other fields over a clear text HTTP communication.
Basic authentication does not provide any security mechanisms using encryption
standards. PKI certificate-based authentication must be set over a secure
channel to ensure confidentiality and integrity. Basic authentication must not
be set in the manifest file."
  desc  'rationale', ''
  desc  'check', "
    Change to the /etc/kubernetes/manifests/ directory on the Kubernetes Master
Node. Run the command:

    grep -i basic-auth-file *

    If \"basic-auth-file\" is set in the Kubernetes API server manifest file
this is a finding.
  "
  desc 'fix', "Edit the Kubernetes API Server manifest file in the
/etc/kubernetes/manifests directory on the Kubernetes Master Node. Remove the
setting \"--basic-auth-file\"."
  impact 0.7
  tag severity: 'high'
  tag gtitle: 'SRG-APP-000516-CTR-001325'
  tag gid: 'V-242439'
  tag rid: 'SV-242439r712673_rule'
  tag stig_id: 'CNTR-K8-002620'
  tag fix_id: 'F-45672r712672_fix'
  tag cci: ['CCI-002418']
  tag nist: ['SC-8']

  unless kube_apiserver.exist?
    impact 0.0
    desc 'caveat', 'Kubernetes API Server process is not running on the target.'
  end

  describe kube_apiserver do
    its('basic-auth-file') { should be_nil }
  end
end
