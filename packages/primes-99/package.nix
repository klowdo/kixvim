{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "primes-99";
  src = inputs.primes-99;
  version = inputs.primes-99.shortRev;

  nvimSkipModule = [
    "99.editor.lsp"
    "99.test.agents_spec"
    "99.test.completions_spec"
    "99.test.files_spec"
    "99.test.geo_spec"
    "99.test.in_flight_spec"
    "99.test.marks_spec"
    "99.test.open_spec"
    "99.test.prompt_spec"
    "99.test.providers_spec"
    "99.test.qfix_helpers_spec"
    "99.test.request_spec"
    "99.test.request_status_spec"
    "99.test.state_spec"
    "99.test.test_utils"
    "99.test.throbber_spec"
    "99.test.tracking_spec"
    "99.test.utils_spec"
    "99.test.visual_spec"
    "99.test.window_spec"
    "99.test.worker_spec"
  ];
}
