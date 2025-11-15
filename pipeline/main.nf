#!/usr/bin/env nextflow
// hash:sha256:48631e59f241b143b0e33cc804a836fdad37e3c9b069da2a5b4cdf60001262ea

// capsule - aind-disrnn-dispatcher
process capsule_aind_disrnn_dispatcher_1 {
	tag 'capsule-7242130'
	container "$REGISTRY_HOST/capsule/3dcc1e97-6f2c-44bc-8b0e-4b715559b4a4:efbcdd4123fe89272ae85b6c612d292d"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=3dcc1e97-6f2c-44bc-8b0e-4b715559b4a4
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7242130.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7242130.git" capsule-repo
	fi
	git -C capsule-repo checkout cd034402eecdf56e9a866c48a64d3e708cd33a85 --quiet
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
	// run processes
	capsule_aind_disrnn_dispatcher_1()
}
