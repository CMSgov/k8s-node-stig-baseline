# encoding: UTF-8

control 'V-242445' do
  title 'The Kubernetes component etcd must be owned by etcd.'
  desc  "The Kubernetes etcd key-value store provides a way to store data to
the Master Node. If these files can be changed, data to API object and the
master node would be compromised. The scheduler will implement the changes
immediately. Many of the security settings within the document are implemented
through this file."
  desc  'rationale', ''
  desc  'check', "
    Review the ownership of the Kubernetes etcd files by using the command:

    stat -c %U:%G /var/lib/etcd/* | grep -v etcd:etcd

    If the command returns any non etcd:etcd file permissions, this is a
finding.
  "
  desc 'fix', "
    Change the ownership of the manifest files to etcd:etcd by executing the
command:

    chown etcd:etcd /var/lib/etcd/*
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000516-CTR-001325'
  tag gid: 'V-242445'
  tag rid: 'SV-242445r712691_rule'
  tag stig_id: 'CNTR-K8-003120'
  tag fix_id: 'F-45678r712690_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  if etcd.exist?
    describe.one do
      if etcd.params['data-dir']
        describe file(etcd.params['data-dir'].join) do
          it { should be_owned_by('etcd') }
          it { should be_grouped_into('etcd') }
        end
      end

      describe file(process_env_var('etcd').params['ETCD_DATA_DIR']) do
        it { should be_owned_by('etcd') }
        it { should be_grouped_into('etcd') }
      end
    end
  else
    describe 'ETCD process is not running on the target.' do
      skip
    end
  end
end
