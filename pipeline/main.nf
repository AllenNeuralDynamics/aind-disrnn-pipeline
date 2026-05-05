#!/usr/bin/env nextflow
// hash:sha256:9430bcf2b8a252d2a5adaa48f783460e96ffc34fa0fee0eeffaea7494b6d65c9

// capsule - aind-disrnn-dispatcher-PCK_duplicate
process capsule_aind_disrnn_dispatcher_pck_duplicate_1 {
	tag 'capsule-8081844'
	container "$REGISTRY_HOST/capsule/f25e57f3-3736-4866-b03b-722382be4a04:efbcdd4123fe89272ae85b6c612d292d"

	cpus 1
	memory '7.5 GB'

	output:
	path 'capsule/results/*', emit: to_capsule_aind_disrnn_wrapper_pck_duplicate_2_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=f25e57f3-3736-4866-b03b-722382be4a04
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8081844.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8081844.git" capsule-repo
	fi
	git -C capsule-repo checkout bc506c71ef28acf04f678ab79d815832e42e9c96 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_disrnn_dispatcher_pck_duplicate_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-disrnn-wrapper-PCK_duplicate
process capsule_aind_disrnn_wrapper_pck_duplicate_2 {
	tag 'capsule-0307129'
	container "$REGISTRY_HOST/capsule/38d91e94-fb45-4fe7-8c72-abc09b219cb0:c165165a8899fb6bac4f2cff6577034d"

	cpus 8
	memory '30 GB'

	publishDir "$RESULTS_PATH/$index", saveAs: { filename -> new File(filename).getName() }

	input:
	val path1
	path 'capsule/data/jobs'
	val index

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=38d91e94-fb45-4fe7-8c72-abc09b219cb0
	export CO_CPUS=8
	export CO_MEMORY=32212254720

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/mice_multisubject_train10-gru-260323/$path1" "capsule/data/$path1" # id: 41983b7d-5708-42a1-9862-4bef8b11da1f
	ln -s "/tmp/data/mice_snapshot_4" "capsule/data/mice_snapshot_4" # id: 5beb1741-1285-46dc-bbeb-64c29a4ad158
	ln -s "/tmp/data/mice_snapshot_3" "capsule/data/mice_snapshot_3" # id: c1b3e0ee-baff-4cf3-9e62-0790fb2855bb
	ln -s "/tmp/data/mice_snapshot_2" "capsule/data/mice_snapshot_2" # id: 630a1fe9-2df1-44a5-996a-432a6d099e04
	ln -s "/tmp/data/mice_snapshot_1" "capsule/data/mice_snapshot_1" # id: ccf1dc32-9d83-425e-ae6d-70e183c58778
	ln -s "/tmp/data/mice_snapshot" "capsule/data/mice_snapshot" # id: 66778003-ad33-41ae-a345-dd4467012e42

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0307129.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0307129.git" capsule-repo
	fi
	git -C capsule-repo checkout 69988ff4042831f0ce74f96f36c1b54b6a611181 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

workflow {
	// input data
	mice_multisubject_train10_gru_260323_to_aind_disrnn_wrapper_pck_duplicate_1 = Channel.fromPath("../data/mice_multisubject_train10-gru-260323/*", type: 'any', relative: true)
	index = Channel.of(1..100000)

	// run processes
	capsule_aind_disrnn_dispatcher_pck_duplicate_1()
	capsule_aind_disrnn_wrapper_pck_duplicate_2(mice_multisubject_train10_gru_260323_to_aind_disrnn_wrapper_pck_duplicate_1, capsule_aind_disrnn_dispatcher_pck_duplicate_1.out.to_capsule_aind_disrnn_wrapper_pck_duplicate_2_2.flatten(), index)
}
