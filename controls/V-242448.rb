# encoding: UTF-8

control 'V-242448' do
  title 'The Kubernetes Kube Proxy must be owned by root.'
  desc  "The Kubernetes kube proxy kubeconfig contain the argument and setting
for the Master Nodes. These settings contain network rules for restricting
network communication between pods, clusters, and networks. If these files can
be changed, data traversing between the Kubernetes Control Panel components
would be compromised. Many of the security settings within the document are
implemented through this file."
  desc  'rationale', ''
  desc  'check', "
    Check if Kube-Proxy is running use the following command:
    ps -ef | grep kube-proxy

    If Kube-Proxy exists:
    Review the permissions of the Kubernetes Kube Proxy by using the command:
    stat -c   %U:%G <location from --kubeconfig>| grep -v root:root

    If the command returns any non root:root file permissions, this is a
finding.
  "
  desc 'fix', "
    Change the ownership of the Kube Proxy to root:root by executing the
command:

    chown root:root <location from kubeconfig>.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000516-CTR-001325'
  tag gid: 'V-242448'
  tag rid: 'SV-242448r712700_rule'
  tag stig_id: 'CNTR-K8-003150'
  tag fix_id: 'F-45681r712699_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  unless kube_proxy.exist?
    impact 0.0
    desc 'caveat', 'Kube-Proxy process is not running on the target.'
  end

  describe kube_proxy do
    its('kubeconfig_file') { should_not be_nil }
    its('kubeconfig_file') { should be_owned_by('root') }
    its('kubeconfig_file') { should be_grouped_into('root') }
  end
end
