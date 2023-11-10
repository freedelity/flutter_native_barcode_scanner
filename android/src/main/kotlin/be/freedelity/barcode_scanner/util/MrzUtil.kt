package be.freedelity.barcode_scanner.util

import android.util.Log
import com.google.mlkit.vision.text.Text

/**
 * A **machine-readable passport (MRP)** is a machine-readable travel document (MRTD) with the data on the identity page encoded in optical character recognition format.
 *
 * Most travel passports worldwide are **MRPs**. They are standardized by the ICAO Document 9303 and have a special **machine-readable zone (MRZ)**, which is usually at the bottom of the identity page at the beginning of a passport
 *
 * There is three types of MRZ format and **Belgian eID is Type 1**
 * - "Type 1" is of a credit card-size with 3 lines × 30 characters.
 * - "Type 2" is relatively rare with 2 lines × 36 characters.
 * - "Type 3" is typical of passport booklets. The MRZ consists of 2 lines × 44 characters.
 *
 * **For all three formats the only characters A to Z (upper case), 0–9, and left angle bracket (<) are allowed**
 *
 * *Source : [Wikipedia: Machine-readable passport](https://en.wikipedia.org/wiki/Machine-readable_passport)*
 */
object MrzUtil {

    private const val T1_TD1_FIRST = "^[IAC][CDP<][A-Z<]{3}[A-Z\\d<]{9}[\\d<][A-Z\\d<]{0,15}\$"
    private const val T1_TD1_SECOND = "^\\d{7}[A-Z<]\\d{7}[A-Z<]{3}[A-Z\\d<]{11}\\d\$"
    private const val T1_TD1_THIRD = "^[A-Z<]{30}\$"

    /**
     * ## Type 1 : Official travel documents
     * The data of the machine-readable zone come in two different formats
     * - TD1 : 3 rows of 30 characters each. (Belgian eID)
     * - TD2 : 2 rows of 36 characters
     * ## Type 2 : Machine-readable visas
     * They come in two different formats:
     * - MRV-A : 2 × 44 chars
     * - MRV-B : 2 × 36 chars
     * ## Type 3 : Passport booklets
     * The data of the machine-readable zone consists of 2 rows of 44 characters each.
     */
    fun extractMRZ(textBlocks: List<Text.TextBlock>, mrzResult: MutableList<String>): String? {

        textBlocks.forEach { textBlock ->

            val mrzLength = textBlock.lines.last().text.length
            val mrzLines: List<Text.Line> = textBlock.lines.takeLastWhile { it.text.length == mrzLength }

            mrzLines.forEach { line ->

                val text = line.text.replace("«", "<").replace(" ", "").uppercase().trim()

                if (text.matches("^[A-Z0-9<]*$".toRegex())) {

                    if (text.matches("^\\d{7}[A-Z<]\\d{7}[A-Z<]{3}[A-Z\\d<]{11}\\d\$".toRegex())) {
                        Log.i("native_scanner", "#################################### DID IT !!!!! $text")
                    }

                    if (((mrzResult.size < 3 && text.length == 30) || mrzResult.size < 2 && (text.length == 36 || text.length == 44))) {

                        if (!mrzResult.any { res -> res.substring(0, 20) == text.substring(0, 20) } && (mrzResult.isEmpty() || mrzResult.first().length == text.length)) {

                            mrzResult.add(text)

                            if (mrzResult.size == 3 && !mrzResult.any{ it[0].isDigit() && it[1].isDigit() }) {
                                mrzResult.clear()
                            }

                        } else if (mrzResult.any { res -> res.substring(0, 20) == text.substring(0, 20) && res.length != text.length }) {

                            mrzResult.clear()

                        }
                    }
                }
            }
        }

        if ((mrzResult.size == 3 && mrzResult.first().length == 30) ||
            (mrzResult.size == 2 && (mrzResult.first().length == 44 || mrzResult.first().length == 36))) {

            val map = mutableMapOf<Int, String>()
            val missed = mutableListOf<Int>()

            mrzResult.forEachIndexed{ index, it ->

                Log.i("native_scanner_res", "result : $mrzResult")

                if (mrzResult.size == 3) {

                    if (it.matches(T1_TD1_FIRST.toRegex())) {
                        map[0] = it
                    } else if (it.matches(T1_TD1_SECOND.toRegex())) {
                        map[1] = it
                    } else if (it.matches(T1_TD1_THIRD.toRegex())) {
                        map[2] = it
                    } else {
                        missed.add(index)
                    }

                } else {
                    if (map.contains(0)) {
                        map[1] = it
                    } else {
                        map[0] = it
                    }
                }

            }

            if (missed.isNotEmpty()) {
                missed.forEach { mrzResult.removeAt(it) }
            } else {
                var result = "${map[0]}\n${map[1]}"
                if (mrzResult.size == 3) result += "\n${map[2]}"
                return result
            }
        }

        return null
    }
}