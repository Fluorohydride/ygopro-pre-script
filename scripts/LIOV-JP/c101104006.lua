--驚きの管理者<∀rlechino> 
--Amazement Administrator <∀rlechino>
--LUA by Kohana Sonogami
--
function c101104006.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101104006)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101104006.spcon)
	e1:SetTarget(c101104006.sptg)
	e1:SetOperation(c101104006.spop)
	c:RegisterEffect(e1)
	--Equip 1 of those with 1 "∀ttraction" 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104006,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101104006+100)
	e2:SetTarget(c101104006.eqtg)
	e2:SetOperation(c101104006.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Destroy that many cards your opponent's controls
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c101104006.descost)
	e4:SetTarget(c101104006.destg)
	e4:SetOperation(c101104006.desop)
	c:RegisterEffect(e4)
end
function c101104006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function c101104006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101104006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101104006.cfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and not c:IsForbidden() and c:GetSummonPlayer()~=tp
end
function c101104006.eqfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x25a) and not c:IsForbidden()
end
function c101104006.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c101104006.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101104006.eqfilter,tp,LOCATION_DECK,0,1,e:GetHandler())
		and eg:IsExists(c101104006.cfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c101104006.cfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c101104006.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101104006.eqfilter),tp,LOCATION_DECK,0,1,1,nil)
		local ec=g:GetFirst() 
		if ec then
			if not Duel.Equip(1-tp,ec,tc) then return end
			--Equip Limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(c101104006.eqlimit)
			ec:RegisterEffect(e1)
		end
	end
end
function c101104006.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c101104006.rfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x25d) and c:IsAbleToRemoveAsCost()
end
function c101104006.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101104006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c101104006.rfilter,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		else return false end
	end
	e:SetLabel(0)
	local rt=Duel.GetTargetCount(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c101104006.rfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
	local ct=cg:GetCount()
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101104006.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
