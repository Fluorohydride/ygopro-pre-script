--クロス・オーバー
--
--Script by mercury233
--Effect not fully confirmed
function c100309042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100309042+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100309042.target)
	e1:SetOperation(c100309042.activate)
	c:RegisterEffect(e1)
end
function c100309042.eqfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c100309042.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c100309042.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	if chk==0 then return ct>0
		and Duel.IsExistingTarget(c100309042.eqfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c100309042.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c100309042.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c100309042.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100309042.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local hc=g:GetFirst()
	if hc==tc then hc=g:GetNext() end
	if hc:IsControler(tp) and tc:IsFaceup() and tc:IsRelateToEffect(e) 
		and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) 
		and tc:IsAbleToChangeControler() then
		if hc:IsFaceup() and hc:IsRelateToEffect(e) 
			and hc:IsLocation(LOCATION_MZONE) then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				if Duel.Equip(tp,tc,hc,false) then
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(hc)
				e1:SetValue(c100309042.eqlimit)
				tc:RegisterEffect(e1,true)
				--substitute
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_DESTROY_REPLACE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetTarget(c100309042.desreptg)
				e2:SetOperation(c100309042.desrepop)
				tc:RegisterEffect(e2,true)
				--damage 0
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				hc:RegisterEffect(e3,true)
				end
			else Duel.Destroy(tc,REASON_RULE)
			end
		else Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
end
function c100309042.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c100309042.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return c:IsDestructable(e) 
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and tg 
		and tg:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and not tg:IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(100309042,0))
end
function c100309042.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
