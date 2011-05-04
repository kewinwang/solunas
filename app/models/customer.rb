#************************************************************************/
#* SOLUNAS BOOKING ENGINE                                               */
#* ======================                                               */
#*                                                                      */
#* Copyright (c) 2006 by Marc Isemann                                   */
#* http://sourceforge.net/projects/solunas                              */
#*                                                                      */
#* This program is free software. You can redistribute it and/or modify */
#* it under the terms of the GNU General Public License as published by */
#* the Free Software Foundation; either version 2 of the License.       */
#************************************************************************/

class Customer < ActiveRecord::Base
has_many :contracts
has_many :notes

  validates_presence_of   :name,:street,:city,:country,:zip

end
