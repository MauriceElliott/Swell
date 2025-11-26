import Foundation

func flush_stdout() {
	#if os(macOS)
	fflush(stdout)
	#else
	fflush(nil)
	#endif
}
