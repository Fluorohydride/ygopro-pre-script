--サクリファイス・アニマ
--Relinquished Anima
--Script by dest
function c100203028.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100203028.matfilter,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100203028,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100203028)
	e1:SetCondition(c100203028.eqcon)
	e1:SetTarget(c100203028.eqtg)
	e1:SetOperation(c100203028.eqop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c100203028.adcon)
	e2:SetValue(c100203028.atkval)
	c:RegisterEffect(e2)
end
function c100203028.matfilter(c)
	return c:IsLevel(1) and not c:IsLinkType(TYPE_TOKEN)
end
function c100203028.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return c100203028.can_equip_monster(e:GetHandler())
end
function c100203028.eqfilter(c)
	return c:GetFlagEffect(100203028)~=0
end
function c100203028.can_equip_monster(c)
	local g=c:GetEquipGroup():Filter(c100203028.eqfilter,nil)
	return g:GetCount()==0
end
function c100203028.eqfilter2(c,tp,lg)
	return c:IsFaceup() and (c:IsAbleToChangeControler() or c:IsControler(tp)) and lg:IsContains(c)
end
function c100203028.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100203028.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100203028.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lg)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100203028.eqlimit(e,c)
	return e:GetOwner()==c
end
function c100203028.equip_monster(c,tp,tc)
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(100203028,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c100203028.eqlimit)
	tc:RegisterEffect(e1)
end
function c100203028.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsRelateToEffect(e) then
			c100203028.equip_monster(c,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c100203028.adcon(e)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c100203028.eqfilter,nil)
	return g:GetCount()>0
end
function c100203028.atkval(e,c)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c100203028.eqfilter,nil)
	local atk=g:GetFirst():GetTextAttack()
	if bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==0 or atk<0 then
		return 0
	else
		return atk
	end
end
