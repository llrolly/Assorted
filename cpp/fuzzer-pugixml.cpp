// Ran all fuzzers in combination for a total execution count of ~4,269,749,078
// Lib Fuzzer execs: 1,035,249,078
// AFL++ execs: ~3,234,500,000
// Found 6 hangs, no crashes
// Basic fuzzer for pugixml parser using AFL++
// https://github.com/zeux/pugixml

#include "pugixml.hpp"
#include <iostream>
#include <fstream>

using namespace pugi;

int main(int argc, char **argv) {
	if (argc < 2){
        std::cerr << "Usage: " << argv[0] << " <xml_file>" << std::endl;
        return 1;
	}

	xml_document doc;
	doc.load_file(argv[1]);

	for (xml_node node : doc.children()) {
		for (xml_node child : node.children()) {
    		volatile auto name = child.name();
			(void)name;
		}
    }

	return 0;
}


// Basic fuzzer for pugixml parser using libFuzzer
// https://github.com/zeux/pugixml

#include "pugixml.cpp"
#include <iostream>
#include <fstream>

using namespace pugi;

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size){

	xml_document doc;
	doc.load_buffer(Data, Size);

	for (xml_node node : doc.children()) {
		for (xml_node child : node.children()) {
    		volatile auto name = child.name();
			(void)name;
		}
    }
	return 0;
}


// Vibecoded Harness for pugixml parser using AFL++

#include <unistd.h>
#include <stdint.h>
#include <stddef.h>
#include <string>
#include <vector>
#include <sstream>

#include "pugixml.hpp"

int main() {
    static uint8_t buf[1 << 20]; // 1MB input buffer

    while (__AFL_LOOP(1000)) {
        ssize_t len = read(0, buf, sizeof(buf));
        if (len <= 0) continue;

        const uint8_t* data = buf;
        size_t size = (size_t)len;

        if (size < 1) continue;

        // --- Split input into XML + XPath ---
        size_t split = data[0] % size;

        std::string xml((const char*)data, split);
        std::string xpath((const char*)(data + split), size - split);

        xml.push_back('\0');
        xpath.push_back('\0');

        // --- 1. Standard parsing ---
        pugi::xml_document doc;
        doc.load_buffer(xml.c_str(), xml.size());

        // --- 2. In-place parsing (mutation-heavy path) ---
        if (!xml.empty()) {
            std::vector<char> inplace(xml.begin(), xml.end());
            pugi::xml_document doc2;
            doc2.load_buffer_inplace(inplace.data(), inplace.size());
        }

        // --- 3. DOM mutation ---
        pugi::xml_node root = doc.document_element();
        if (root) {
            pugi::xml_node child = root.append_child("fuzz");

            child.append_attribute("attr") = xml.c_str();

            // Copy node (ownership + allocation paths)
            root.append_copy(child);

            // Remove node (free paths)
            root.remove_child(child);
        }

        // --- 4. Traversal ---
        for (pugi::xml_node n = doc.first_child(); n; n = n.next_sibling()) {
            for (pugi::xml_node c = n.first_child(); c; c = c.next_sibling()) {
                (void)c.name();
                (void)c.value();
            }
        }

        // --- 5. XPath evaluation ---
        try {
            pugi::xpath_query query(xpath.c_str());
            query.evaluate_node_set(doc);
        } catch (...) {
            // Ignore parser/eval exceptions
        }

        // --- 6. Serialization ---
        std::ostringstream oss;
        doc.save(oss);
    }

	return 0;
}
