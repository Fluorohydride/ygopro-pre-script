--十二獣ドランシア
--Juunishishi Drancia
--Script by nekrozar
function c100911053.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c100911053.xyzcon)
	e1:SetTarget(c100911053.xyztg)
	e1:SetOperation(c100911053.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c100911053.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c100911053.defval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100911053,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCost(c100911053.descost)
	e4:SetTarget(c100911053.destg)
	e4:SetOperation(c100911053.desop)
	c:RegisterEffect(e4)
end
function c100911053.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x1f2) and not c:IsCode(xyzc:GetCode()) and c:IsCanBeXyzMaterial(xyzc)
		and Duel.GetFlagEffect(tp,100911053)==0
end
function c100911053.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 4<=ct then return false end
	if min and (min>4 or max<4) then return false end
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	if ct<3 and (not min or min<=3) and mg:IsExists(c100911053.ovfilter,1,nil,tp,c) then
		return true
	end
	return Duel.CheckXyzMaterial(c,nil,4,4,4,og)
end
function c100911053.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	local b1=Duel.CheckXyzMaterial(c,nil,4,4,4,og)
	local b2=ct<3 and (not min or min<=3) and mg:IsExists(c100911053.ovfilter,1,nil,tp,c)
	local g=nil
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(100911053,0))) then
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c100911053.ovfilter,1,1,nil,tp,c)
		Duel.RegisterFlagEffect(tp,100911053,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetLabel(0)
		g=Duel.SelectXyzMaterial(tp,c,nil,4,4,4,og)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c100911053.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		if e:GetLabel()==1 then
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function c100911053.atkfilter(c)
	return c:IsSetCard(0x1f2) and c:GetAttack()>=0
end
function c100911053.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911053.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c100911053.deffilter(c)
	return c:IsSetCard(0x1f2) and c:GetDefense()>=0
end
function c100911053.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911053.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c100911053.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100911053.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100911053.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
